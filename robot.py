import random

class Robot:
    def __init__(self, color, position, direction):
        self.color = color
        self.position = position
        self.direction = direction

    def move(self):

        distance = random.randint(20,40) if self.color =='red' else random.randint(30,50)

        self.position += self.direction * distance

        if self.position < 0 :
            self.position = -self.position
            self.direction *= -1

        elif self.position > 100:
            excess = self.position -100

            self.position = 100 - excess
            self.direction *= -1

# list of 150 robot


robots = [
    Robot('red',random.uniform(0,100), random.choice([-1,1])) for _ in range(50)
] + [
    Robot('yellow', random.uniform(0,100), random.choice([-1, 1])) for _ in range(100) 
]

# moving for 200 iteration
for _ in range(200):
    for robot in robots:
        robot.move()

# filtering first half robots
robots_in_first_half = list(filter(lambda r: r.position  <=50, robots))


# save the remaining robots position in text file
with open("remaining_robots.txt",'w')as file;
    for robot in robots_in_first_half:
        file.write(f"Color: {robot.color}, Position: {robot.position:.2f}\n")


        