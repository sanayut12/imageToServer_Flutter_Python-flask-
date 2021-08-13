from flask import Response, Flask , request
from flask.wrappers import Request
import numpy as np
import base64
# from io import BytesIO
# from PIL import Image
import cv2
import time
app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

@app.route("/image",methods = ['POST'])
def imagess():
    image = request.json['image']

    ################ base64 to PIL Image##################
    # r = base64.b64decode(image)
    # # base64.decode(image)
    # # print(type(r))
    # im_file = BytesIO(r)
    # img = Image.open(im_file)  
    # # print(img.size) #เช็คขนาดของภาพ
    # print(img.size)
    #######################จบ ##################

    #################base64 to OpenCV Image #####################
    im_bytes = base64.b64decode(image)
    im_arr = np.frombuffer(im_bytes, dtype=np.uint8)  # im_arr is one-dim Numpy array
    img = cv2.imdecode(im_arr, flags=cv2.IMREAD_COLOR)
    print(img)
    # cv2.imshow("fefef",img)
    cv2.imwrite("ddd.jpg",img)
    # time.sleep(2000)
    return "image"

app.run("192.168.137.1",port=3000)