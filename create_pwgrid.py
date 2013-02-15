#!/usr/bin/env python
import random

random.seed()

legal_secrets = map(chr, range(65, 91))
legal_secrets = legal_secrets + [ls.lower() for ls in legal_secrets]
legal_secrets = legal_secrets + map(chr, range(33, 65))

letters = ["."] + map(chr, range(65, 91)) + ["."]
letters = [" %s " % letter for letter in letters]

lines = ["---"] * 28

numbers = map(str, range(1, 10))

def render_header():
    print " ".join(letters)
    print " ".join(lines)

def get_next_secret():
    return random.choice(legal_secrets)

render_header()

for number in numbers:
    secrets = [number] + [get_next_secret() for i in range(0, 26)] + [number]
    print " ".join([" %s " % secret for secret in secrets])
print

render_header()



