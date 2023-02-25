import heapq
import cv2
import numpy as np
import sys
import os
import math
args = sys.argv

IMAGE_SIZE = 512

#Helper functions and classes
class Vertex:
    def __init__(self,x_coord,y_coord):
        self.x=x_coord
        self.y=y_coord
        self.d=float('inf') #distance from source
        self.parent_x=None
        self.parent_y=None
        self.processed=False
        self.index_in_queue=None

#Return neighbor directly above, below, right, and left
def get_neighbors(mat,r,c):
    shape=mat.shape
    neighbors=[]
    #ensure neighbors are within image boundaries
    if r > 0 and not mat[r-1][c].processed:
         neighbors.append(mat[r-1][c])
    if r < shape[0] - 1 and not mat[r+1][c].processed:
            neighbors.append(mat[r+1][c])
    if c > 0 and not mat[r][c-1].processed:
        neighbors.append(mat[r][c-1])
    if c < shape[1] - 1 and not mat[r][c+1].processed:
            neighbors.append(mat[r][c+1])
    return neighbors

def bubble_up(queue, index):
    if index <= 0:
        return queue
    p_index=(index-1)//2
    if queue[index].d < queue[p_index].d:
            queue[index], queue[p_index]=queue[p_index], queue[index]
            queue[index].index_in_queue=index
            queue[p_index].index_in_queue=p_index
            quque = bubble_up(queue, p_index)
    return queue
    
def bubble_down(queue, index):
    length=len(queue)
    lc_index=2*index+1
    rc_index=lc_index+1
    if lc_index >= length:
        return queue
    if lc_index < length and rc_index >= length: #just left child
        if queue[index].d > queue[lc_index].d:
            queue[index], queue[lc_index]=queue[lc_index], queue[index]
            queue[index].index_in_queue=index
            queue[lc_index].index_in_queue=lc_index
            queue = bubble_down(queue, lc_index)
    else:
        small = lc_index
        if queue[lc_index].d > queue[rc_index].d:
            small = rc_index
        if queue[small].d < queue[index].d:
            queue[index],queue[small]=queue[small],queue[index]
            queue[index].index_in_queue=index
            queue[small].index_in_queue=small
            queue = bubble_down(queue, small)
    return queue

def get_distance(img,u,v):
    return 0.1 + (float(img[v][0])-float(img[u][0]))**2+(float(img[v][1])-float(img[u][1]))**2+(float(img[v][2])-float(img[u][2]))**2


def find_shortest_path(img,src,dst):
    pq=[] #min-heap priority queue
    source_x=src[0]
    source_y=src[1]
    dest_x=dst[0]
    dest_y=dst[1]
    imagerows,imagecols=img.shape[0],img.shape[1]
    matrix = np.full((imagerows, imagecols), None) #access by matrix[row][col]
    for r in range(imagerows):
        for c in range(imagecols):
            matrix[r][c]=Vertex(c,r)
            matrix[r][c].index_in_queue=len(pq)
            pq.append(matrix[r][c])
    matrix[source_y][source_x].d=0
    pq=bubble_up(pq, matrix[source_y][source_x].index_in_queue)
    
    while len(pq) > 0:
        u=pq[0]
        u.processed=True
        pq[0]=pq[-1]
        pq[0].index_in_queue=0
        pq.pop()
        pq=bubble_down(pq,0)
        neighbors = get_neighbors(matrix,u.y,u.x)
        for v in neighbors:
            dist=get_distance(img,(u.y,u.x),(v.y,v.x))
            if u.d + dist < v.d:
                v.d = u.d+dist
                v.parent_x=u.x
                v.parent_y=u.y
                idx=v.index_in_queue
                pq=bubble_down(pq,idx)
                pq=bubble_up(pq,idx)
                          
    path=[]
    iter_v=matrix[dest_y][dest_x]
    path.append((dest_x,dest_y))
    while(iter_v.y!=source_y or iter_v.x!=source_x):
        path.append((iter_v.x,iter_v.y))
        iter_v=matrix[iter_v.parent_y][iter_v.parent_x]
      
    path.append((source_x,source_y))
    return path

def smooth(path, weight_data = 0.05, weight_smooth = 0.3, tolerance = 0.00001):
#path, weight_data = 0.5, weight_smooth = 0.1,平準化パラメータ tolerance = 0.00001 パスの変化量の閾値
    # Make a deep copy of path into newpath
    newpath = [[0 for col in range(len(path[0]))] for row in range(len(path))]
    for i in range(len(path)):
        for j in range(len(path[0])):
            newpath[i][j] = path[i][j]

    #### ENTER CODE BELOW THIS LINE ###
    change = 1
    while change > tolerance:
        change = 0
        for i in range(1,len(path)-1):
            for j in range(len(path[0])):
                ori = newpath[i][j]
                newpath[i][j] = newpath[i][j] + weight_data*(path[i][j]-newpath[i][j])
                newpath[i][j] = newpath[i][j] + weight_smooth*(newpath[i+1][j]+newpath[i-1][j]-2*newpath[i][j])
                change += abs(ori - newpath[i][j])
    
    for i in range(1,len(newpath)-1):
        for j in range(2):
            newpath[i][j] = my_round_int(newpath[i][j])
    
    return newpath # Leave this line for the grader!
    
stdval=0

def nearPoint(x, y, points):
    result = {}
    if len(points) == 0:
        return result
    result[0] = points[0][0]
    result[1] = points[0][1]
    stdval = math.sqrt((points[0][0] - x) ** 2 + (points[0][1] - y) ** 2)
    for point in points:
        distance = math.sqrt((point[0] - x) ** 2 + (point[1] - y) ** 2)
        if stdval > distance:
            result[0] = point[0]
            result[1] = point[1]
            stdval = distance
    kekka = [my_round_int(result[0]), my_round_int(result[1])]
    return kekka, stdval

    
def readtxt(labels_dir, points):
    f = open(labels_dir, 'r')
    label_info = f.readlines()
    for data in label_info:
        label, x_coordinate, y_coordinate, x_size, y_size = data.split()
        points.append([my_round_int(IMAGE_SIZE*float(x_coordinate)), my_round_int(IMAGE_SIZE*float(y_coordinate))])
        #print(label + ' ' + x_coordinate + ' ' + y_coordinate + ' ' + x_size + ' ' + y_size )

def readheretxt(labels_dir, points):
    f = open(labels_dir, 'r')
    label_info = f.readlines()
    for data in label_info:
        label, x_coordinate, y_coordinate, x_size, y_size = data.split()
        if label == '1':
            points.append(my_round_int(IMAGE_SIZE*float(x_coordinate)))
            points.append(my_round_int(IMAGE_SIZE*float(y_coordinate)))
        #print(label + ' ' + x_coordinate + ' ' + y_coordinate + ' ' + x_size + ' ' + y_size )
    if len(points) == 0:
        for data in label_info:
            label, x_coordinate, y_coordinate, x_size, y_size = data.split()
            if label == '0':
                points.append(my_round_int(IMAGE_SIZE*float(x_coordinate)))
                points.append(my_round_int(IMAGE_SIZE*float(y_coordinate))-20)
                print(points)

magni_w = 32.64/IMAGE_SIZE
magni_h = 24.48/IMAGE_SIZE

def henkan(p):
    for x in range(len(p)):
        p[x][0] =  round(magni_w*p[x][0]-16.32,1)
        p[x][1] =  round(magni_h*(IMAGE_SIZE-p[x][1])-12.24,1)

def shiborikomi(path):
    p = []
    n = 17
    for i in range(int(len(path)/n)):
        p.append(path[i*n])
    return p 
    


def main():
    start = []
    p_1f = []
    p_2f = []
    p_3f = []
    a = []
    b = []

    # 画像読み込み
    original = cv2.imread('images/map1.png')
    h, w, c = original.shape
    image1 = cv2.imread('DetectImages/map1p.png')

    goal = (my_round_int(int(args[1])*IMAGE_SIZE/w), my_round_int(int(args[2])*IMAGE_SIZE/h))
    print(goal)
    goal_f = int(args[3])
   
    #1Fの処理
    here_dir = 'runs/detect/here/labels/map1.txt'
    
    readheretxt(here_dir, start)
    print(start)


    ev_dir = "runs/detect/exp/labels/"
    readtxt(ev_dir+"map1.txt", p_1f)
    readtxt(ev_dir+"map2.txt", p_2f)

    if goal_f != 1:
        halfPoint, a = nearPoint(start[0], start[1], p_1f)
        halfPoint2, b = nearPoint(goal[0], goal[1], p_1f)
        b = stdval
        if a > b:
            halfPoint = halfPoint2
        
        path_to_half = find_shortest_path(image1, halfPoint, start)
            
        path_to_half = smooth(path_to_half)      
        path_to_half = shiborikomi(path_to_half)
        henkan(path_to_half)
        with open('jsons/path.txt', 'w') as f:
            for i in range(len(path_to_half)):
                f.write(str(path_to_half[i][0])+","+str(path_to_half[i][1])+",-5.9"+"\n")
            f.write(str(round(magni_w*halfPoint[0]-16.32,1))+","+str(round(magni_h*(IMAGE_SIZE-halfPoint[1])-12.24,1))+",-5.9"+"\n")
    
    if goal_f == 3:
        image3 = cv2.imread('DetectImages/map3p.png')
        readtxt(ev_dir+"map3.txt", p_3f)
        start_half, a = nearPoint(halfPoint[0], halfPoint[1], p_3f)

        half_2f, a = nearPoint(halfPoint[0], halfPoint[1], p_2f)
        half_2f[0] = round(magni_w*half_2f[0]-16.32,1)
        half_2f[1] = round(magni_h*(IMAGE_SIZE-half_2f[1])-12.24,1)
        with open('jsons/path.txt', 'a') as f:
            f.write(str(half_2f[0])+","+str(half_2f[1])+",0.1"+"\n")
        
        path_to_goal = find_shortest_path(image3, goal, start_half)
        path_to_goal = smooth(path_to_goal)
        path_to_goal = shiborikomi(path_to_goal)
        henkan(path_to_goal)
        with open('jsons/path.txt', 'a') as f:
            for i in range(len(path_to_goal)):
                f.write(str(path_to_goal[i][0])+","+str(path_to_goal[i][1])+",6.1"+"\n")    

    elif goal_f == 2:
        image2 = cv2.imread('DetectImages/map2p.png')
        start_half, a = nearPoint(halfPoint[0], halfPoint[1], p_2f)
        path_to_goal = find_shortest_path(image2, goal, start_half)
        path_to_goal = smooth(path_to_goal)
        path_to_goal = shiborikomi(path_to_goal)
        henkan(path_to_goal)
        with open('jsons/path.txt', 'a') as f:
            for i in range(len(path_to_goal)):
                f.write(str(path_to_goal[i][0])+","+str(path_to_goal[i][1])+",0.1"+"\n")        

    else:
        path_to_goal = find_shortest_path(image1, goal, start)
        path_to_goal = smooth(path_to_goal)
        path_to_goal = shiborikomi(path_to_goal)
        henkan(path_to_goal)
        with open('jsons/path.txt', 'w') as f:
            for i in range(len(path_to_goal)):
                f.write(str(path_to_goal[i][0])+","+str(path_to_goal[i][1])+",-5.9"+"\n")




my_round_int = lambda x: int((x * 2 + 1) // 2)

if __name__ == "__main__":
    main()
