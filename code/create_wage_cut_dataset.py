# Title: Wages of Paycuts 
# Author: John Horton
# Date: 12 Feb 09
# Purpose: This code takes the raw survey download 
# from the wages of pay-cuts experiment and 
# creates a single dataset usable in Stata or R

# G1 - Simple Wage Cut - Control Group
# G2 - Simple Wage Cut - Base Treatment Group 
# G3 - Simple Wage Cut - Income Effect Control Group 
# G4 - Simple Wage Cut - Reasonable Group 
# G5 - Simple Wage Cut - Unreasonable Group 
# G6 - Simple Wage Cut - Neighbor Group 
# G7 - Simple Wage Cut - Opt Out Group 
# G8 - Simple Wage Cut - Primed Group 

# To Do: 
# 1. Turn into noweb document
# 2. Edit error rate for all tasks
# 3. Incorporate Rpy? 
 
import sys, csv, time

def argmin (*a):
    """Return two arguments: first the smallest value, second its offset"""
    min = sys.maxint; arg = -1; i = 0
    for x in a:
        if (x < min):
            min = x; arg = i
        i += 1
    return (min,arg)
 
# I got this string edit code form 
# http://www.cs.umass.edu/~mccallum/courses/inlp2007/code/stredit.py      
# http://www.cs.umass.edu/~mccallum/ 
def stredit (s1,s2):
    "Calculate Levenstein edit distance for strings s1 and s2."
    len1 = len(s1) # vertically
    len2 = len(s2) # horizontally
    # Allocate the table
    table = [None]*(len2+1)
    for i in range(len2+1): table[i] = [0]*(len1+1)
    # Initialize the table
    for i in range(1, len2+1): table[i][0] = i
    for i in range(1, len1+1): table[0][i] = i
    # Do dynamic programming
    for i in range(1,len2+1):
        for j in range(1,len1+1):
            if s1[j-1] == s2[i-1]:
                d = 0
            else:
                d = 1
            table[i][j] = min(table[i-1][j-1] + d,
                              table[i-1][j]+1,
                              table[i][j-1]+1)
    return table[len2][len1]

def elapsed_time(start,end):
    st = time.strptime(start, '%m/%d/%Y  %H:%M:%S')
    en = time.strptime(end,   '%m/%d/%Y  %H:%M:%S')
    return time.mktime(en) - time.mktime(st)

def yesno(answer): 
    if answer=='':
        return None
    elif answer=="Yes" or answer=="yes":
        return "TRUE"
    else: 
        return "FALSE" 

def num_hours(answer): 
    if answer=='':
        return None
    elif answer=="Fewer than 10":
        return "FALSE"
    else:
        return "TRUE"


# These files contain the source code for the transcriptions 
FILES = ["sample10.txt", "sample11.txt", "sample12.txt", "sample14.txt"] 

# Turns each file into a single string 
def file_to_string(file_name):
    temp = open(file_name,"rU")
    task = temp.readlines()
    temp.close()
    temp_string = ""
    for i in task: 
        t = i 
        t = t.replace("\n"," ")
        temp_string = temp_string + t
    return temp_string 

# loads correct spellings 
tasks = [file_to_string(file) for file in FILES] 

# each of the CSV sheets has a slightly different format depending 
# on the treatment.  This code creates custom dictionaries for 
# each of the experiment types.  The appropriate dictionary is 
# passed to the observation class. 

standard_dict = {"start_time":2, "end_time":3, "x1":9,
"x2":10,"x3":11,"add":12,"x4":13,"trust":14,"advice":15,
"survey":16, "patient":17,"male":18,"eng":19,"gt10":20,"uscan":21, "code":22}

# Key for G3 (no add or x4)  
G3_dict = dict(standard_dict.items()) 
del G3_dict["add"]
del G3_dict["x4"]
mod_keys = ["trust", "advice", "survey", "patient", "male", "eng", "gt10", "uscan", "code"]
for key in mod_keys: 
    G3_dict[key] = G3_dict[key] - 2 

G7_dict = dict(standard_dict.items()) 
del G7_dict["add"]
mod_keys = ["x4"] + mod_keys 
for key in mod_keys: 
    G7_dict[key] = G7_dict[key] - 1 

G8_dict = dict(standard_dict.items()) 
mod_keys = ["add"] + mod_keys
for key in mod_keys:
    G8_dict[key] = G8_dict[key] + 1
G8_dict["fair"] = 12
 
class Response(object):
    def __init__(self,line, treat,d):
        self.G = treat
        self.start_time = line[d["start_time"]]
        self.end_time = line[d["end_time"]]
        self.t = elapsed_time(self.start_time,self.end_time)
        self.x1 = line[d["x1"]]
        self.e1 = stredit(self.x1,tasks[0])
        self.x2 = line[d["x2"]]
        self.e2 = stredit(self.x2,tasks[1])
        self.x3 = line[d["x3"]]
        self.e3 = stredit(self.x3,tasks[2])
        # determines if group asked subjects about 
        # doing an additional paragraph 
        if d.has_key("add"):
            self.add = yesno(line[d["add"]])
        else:
            self.add = None 
        if d.has_key("x4"):
            self.x4 = line[d["x4"]] 
            # sees if it is the opt-out group 
            if len(self.x4) > 10 and self.G==7:
                self.add = "TRUE" 
        if self.add=="TRUE":
            self.e4 = stredit(self.x4,tasks[3])
        else:
            self.e4 = None 
        if line[d["trust"]]=='':
            self.trust = None
        else:
            self.trust = int(line[d["trust"]])
        self.advice = len(line[d["advice"]])
        self.survey = yesno(line[d["survey"]])
        self.patient = yesno(line[d["patient"]])
        if line[d["male"]]=="Male":
            self.male = "TRUE"
        elif line[d["male"]]=="Female":
            self.male = "FALSE"
        else:
            self.male = None
        self.eng = yesno(line[d["eng"]])    
        self.gt10 = num_hours(line[d["gt10"]]) 
        self.uscan = yesno(line[d["uscan"]])
        if d.has_key("fair"):
            if line[d["fair"]]=='': 
                self.fair = None
            else: 
                self.fair = float(line[d["fair"]])
        else:
            self.fair = None
        self.code = line[d["code"]]


path = "../raw_data/"        
        
header = ["G", "t", "e1", "e2", "e3","add","e4", "trust", "advice",
          "survey","patient", "male","eng", "gt10", "uscan", "fair", "code"] 

cooked_sheet = []  
for file_index in range(1,9): 
    print file_index 
    if file_index in [1,2,4,5,6]: 
        d = standard_dict 
    elif file_index in [3]:
        d = G3_dict 
    elif file_index in [7]:
        d = G7_dict 
    elif file_index in [8]: 
        d = G8_dict
    file = open(path + "G" + str(file_index) + "/CSV/Sheet_1.csv","rU")
# need to drop first two lines 
    raw_sheet = csv.reader(file,delimiter=",") 
    try:
        raw_sheet.next()
        raw_sheet.next()
    except csv.Error:
        pass
    [cooked_sheet.append(Response(line, file_index,d)) for line in raw_sheet] 
    
f = open("../data/wage_cuts.csv","w")
out = csv.writer(f,delimiter=",")
out.writerow(header)
for obs in cooked_sheet:
    out_row = []
    for heading in header: 
        out_row.append(obs.__dict__[heading])
    out.writerow(out_row)
f.close()    



 
#def compute_pay(i):
   # if code[i]=='':
   #     return "NA"
  #  else:
 #       return treatment[i]*extra[i]*5 + extra[i]*5 + (wage[i]*paras[i] + (30 - 3*wage[i]) - extra[i]*wage[i])  

#payment = [compute_pay(i) for i in range(len(data))]

#P = zip(code,payment)

#g = file("pay_out.csv","w")
#payout = csv.writer(g,delimiter=",")
#payout.writerows(P)
#g.close()
