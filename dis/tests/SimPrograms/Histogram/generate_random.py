#!/usr/bin/env python

from random import randint
import sys

def generate_data():
	data = []

	for i in range(0, 128):
		data += randint(0, 124) * [i]

	return data

def generate_edge_1():
	data = []

	for i in range(0, 128):
		data += 61 * [i]

	return data

def generate_edge_2():
	data = []

	for i in range(0, 128):
		data += 62 * [i]

	return data


def write_to_file(data):
	with open('testdata1.asm', 'w') as fopen:
		fopen.write(".ORIG x4000\n\n")
		fopen.write(".FILL #{}\n".format(len(data)))
		for i in data:
			fopen.write(".FILL #{}\n".format(i))
		fopen.write('\n.END')

if __name__ == '__main__':
	data = None
	case = None
	if len(sys.argv) > 1:
		case = int(sys.argv[1])
	if case == 1:
		data = generate_edge_1()
	elif case == 2:
		data = generate_edge_2()
	else:
		data = generate_data()

	write_to_file(data)
