
import csv, time
file = open("../Results/CSV/Sheet_1.csv","rU")
data1 = csv.reader(file,delimiter=",") 

data = [line for line in bar] 
header = data[0]
del data[0]
d = dict(zip(header,range(len(header))))
foo.close()


FILES = ["sample10.txt", "sample11.txt", "sample12.txt", "sample13.txt", "sample14.txt"] 

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

def elapsed_time(start,end):
    st = time.strptime(start, '%B %d, %Y %I:%M %p')
    en = time.strptime(end, '%B %d, %Y %I:%M %p')
    return time.mktime(en) - time.mktime(st)

def spelling_errors(standard,compare):
    if len(compare) < 1:
        return 'NA' 
    s = set(standard.split(" "))
    c = set(compare.split(" "))
    return len(s) - len(s.intersection(c))

def choice(answer):
    if answer=="Yes":
        return 1
    else:
        return 0

def num_paras(line):
    p1 = 1 if len(line[d['task1']])>10 else 0
    p2 = 1 if len(line[d['task2']])>10 else 0
    p3 = 1 if len(line[d['task3']])>10 else 0
    p4 = 1 if len(line[d['task4']])>10 else 0 
    return p1+p2+p3+p4

def gender(eggs):
    return 1 if eggs=="Male" else 0


def num_words(eggs):
    return len(set(eggs.split(" ")))

#observation specific changes 
    

time = [elapsed_time(line[d['StartDate']],line[d['EndDate']]) for line in data] 

error1 = [spelling_errors(tasks[0],line[d['task1']]) for line in data] 
length1 = [num_words(tasks[0]) for line in data] 


error2 = [spelling_errors(tasks[1],line[d['task2']]) for line in data]
length2 = [num_words(tasks[1]) for line in data] 

error3 = [spelling_errors(tasks[2],line[d['task3']]) for line in data] 
length3 = [num_words(tasks[2]) for line in data] 

error4 = [spelling_errors(tasks[3],line[d['task4']]) for line in data]
length4 = [num_words(tasks[3]) for line in data] 

error5 = [spelling_errors(tasks[4],line[d['task5']]) for line in data]
length5 = [num_words(tasks[4]) for line in data] 

numpar = [num_paras(line) for line in data] 

extra = [choice(line[d['extra']]) for line in data]


#rating = [line[d['rating']] for line in data] 

#xself =  [self_transfer(line[d['split']]) for line in data]
english = [choice(line[d['eng']]) for line in data] 
hours =  [line[d['hours']] for line in data]
confidence =  [line[d['confidence']] for line in data]
us = [choice(line[d['us']]) for line in data] 
male = [gender(line[d['gender']]) for line in data] 
code = [str(line[d['code']]) for line in data] 
treatment = [line[d['treatment']] for line in data] 

header2 = ['treatment', 'time', 'error1', 'length1', 'error2', 'length2', 'error3', 'length3', 'error4', 'length4', 'extra', 'error5', 'length5', 'english','hours','male', 'us', 'confidence','code', 'numpar']
C = zip(treatment, time, error1, length1, error2, length2, error3, length3, error4, length4, extra, error5, length5, english, hours, male, us, confidence, code, numpar)


code = [str(line[d['code']]) for line in data]
 
f = open("exp2clear.csv","w")
out = csv.writer(f,delimiter=",")
out.writerow(header2)
out.writerows(C)
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
