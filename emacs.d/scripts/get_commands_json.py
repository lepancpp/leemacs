import os

meragefiledir = os.getcwd() + '/build_buzzard_isolated'
filenames = os.listdir(meragefiledir)

# create
file = open('compile_commands.json', 'w')
file.write('[')
file.write('\n')

for filename in filenames:
    filepath = meragefiledir + '/' + filename + '/' + 'compile_commands.json'
    if os.path.exists(filepath):
        for line in open(filepath):
            if (line != "[\n") and (line != "]"):
                    file.writelines(line)
        file.write(',')

file.write(']')
file.write('\n')

# close
file.close()
