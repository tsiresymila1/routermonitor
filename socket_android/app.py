from flask import Flask,request,render_template
from flask_socketio import SocketIO
import json
import logging
import socketserver
import _thread as thread
import socket
import requests

app = Flask(__name__)
app.config['SECRET_KEY'] = "randriari§5621&&°%" 
socketio = SocketIO(app)


@app.route('/',methods=['GET','POST'])
def index():
    if request.method == 'POST' :
        data = request.form
        print(data)
        return "Data received"
    else :
        return  "Your are enter"
    

@app.route('/logs',methods=['GET','POST'])
def logs():
    if request.method == 'POST' :
        data = request.form
        
        if data["type"] != "unknown":
            print(data)
            socketio.emit("alert",data)
        else:
            socketio.emit("data",data)
        return "Data received"

@app.route('/login',methods=['GET','POST'])
def login():
    if request.method == 'POST' :
        data = request.form
        files = request.files
        print("Your login data : "+str(data))
        return "Tafiditra ianao"
    else :
        return "Ito ny valin'ilay mangataka fotsiny "

@app.route('/register',methods=['GET','POST'])
def register():
    if request.method == 'POST' :
        print("Your register data : "+str(request.form))
        return 'You enter your register data'
    else :
        return 'Please, enter your register data'

@socketio.on('connect')
def socket_connect():
    print('Client connected')
    socketio.emit('connected')
    
@socketio.on('disconnect')
def socket_disconnect():
    print('Client disconnected')
    socketio.emit('disconnected')

@socketio.on('message')
def socket_message(message):
    print('client send message : '+str(message))

@socketio.on('login')
def socket_login(data):
    print('client send login data : '+json.dumps(data))
    socketio.emit('logged',json.dumps("you're logged"));
    #socketio.emit('notlogged',json.dumps("you aren't logged"));
    # socketio.emit('registered',json.dumps([{"message":"you're logged"}]))

if __name__ == "__main__" :
    ip = socket.gethostbyname(socket.gethostname())
    #thread.start_new_thread(syslogserver.start,())
    socketio.run(app,host="192.168.1.14",port=9998,debug=True)
    
