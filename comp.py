import sys

try:
    this, that = sys.argv[1:3]
except:
    sys.exit('Give two arguments')

this = open(this, 'rb').read()
that = open(that, 'rb').read()

for i, (a, b) in enumerate(zip(this,that)):
    if i < 0x10:
        continue
    if i > 0x8010:
        break
    if a != b:
        print(f'Difference at {i-0x10+0x8000:04x}: {a:02x} != {b:02x}')
