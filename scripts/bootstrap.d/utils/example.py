#!/usr/bin/env python

# Instead of using a list it uses a list of dictionaries
# we can we can do operations with the data
students = []

with open("students.csv") as file:
    for line in file:
        name, house = line.rstrip().split(",")
        student = {"name": name, "house": house}
        students.append(student)


def get_house(student):
    return student["house"]


for student in sorted(students, key=get_house):
    print(f"{student['name']} is in {student['house']}")
