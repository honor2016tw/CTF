import re

Regular = re.compile('FLAG{[\w]+}')

file = open('./flag','r').read()
print(Regular.findall(file))

