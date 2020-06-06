import sqlite3
import os
import re

class DatabaseHelper(object) :

    def __init__(self,name) :
        self.dbname = name
        self.connexion = sqlite3.connect(self.dbname)

    def _open(self) :
        self.cursor = self.connexion.cursor()

    def _create(self,table_name):
        self.table_name = table_name
        sql_request = """CREATE TABLE IF NOT EXISTS """+str(table_name)+""" (
            id integer PRIMARY KEY AUTOINCREMENT,
            user_id text NOT NULL,
            profile text NOT NULL,
            name text NOT NULL,
            lastname text NOT NULL,
            b_day text NOT NULL,
            b_city text NOT NULL,
            class text NOT NULL,
            num_ins text NOT NULL
        )
        """
        self.cursor = self.connexion.cursor()
        a = self.cursor.execute(sql_request)
        self.connexion.commit()
        return a

    def insert(self,data):
        sql_request = """
            INSERT INTO """+str(self.table_name)+""" (user_id,profile,name,lastname,b_day,b_city,class,num_ins) VALUES (?,?,?,?,?,?,?,?)
        """
        self.cursor = self.connexion.cursor()
        rep = self.cursor.execute(sql_request,data)
        self.connexion.commit()

    def getAllByFilter(self,classe,trie,sens):
        if(classe =="Tous"): sql_request = """SELECT * FROM """+str(self.table_name)+""" ORDER BY """+trie+""" """+sens
        else : sql_request = """SELECT * FROM """+str(self.table_name)+""" WHERE class=\""""+classe+"""\" ORDER BY """+trie+""" """+sens
        self.cursor = self.connexion.cursor()
        self.cursor.execute(sql_request)
        data = self.cursor.fetchall()
        self.connexion.commit()
        user_data = []
        for d in data :
            user = {}
            user['id'] = d[0]
            user['userId'] = d[1]
            user['profile'] = d[2]
            user['name'] = d[3]
            user['lastname'] = d[4]
            user['birthdate'] = d[5]
            user['birthcity'] = d[6]
            user['classe'] = d[7]
            user['identifiant'] = d[8]
            user_data.append(user)
        return user_data
    
    def getall(self):
        sql_request = """SELECT * FROM """+str(self.table_name)+""" ORDER BY name ASC """
        self.cursor = self.connexion.cursor()
        self.cursor.execute(sql_request)
        data = self.cursor.fetchall()
        self.connexion.commit()
        user_data = []
        for d in data :
            user = {}
            user['id'] = d[0]
            user['userId'] = d[1]
            user['profile'] = d[2]
            user['name'] = d[3]
            user['lastname'] = d[4]
            user['birthdate'] = d[5]
            user['birthcity'] = d[6]
            user['classe'] = d[7]
            user['identifiant'] = d[8]
            user_data.append(user)
        return user_data
    
    def find(self,name_content,classe,trie,sens):
        sql_request = """SELECT * FROM """+str(self.table_name)+""" WHERE name REGEXP '(^|\D{1})"""+str(name_content)+"""(\D{1}|$)' classe="""+classe+""" ORDER BY """+trie+""" """+sens
        sql_request = """SELECT * FROM """+str(self.table_name)+""" WHERE name REGEXP '(^|\D{1})"""+str(name_content)+"""(\D{1}|$)' ORDER BY """+trie+""" """+sens
        self.connexion.create_function('regexp', 2, lambda x, y: 1 if re.search(x,y) else 0)
        self.cursor = self.connexion.cursor()
        self.cursor.execute(sql_request)
        data = self.cursor.fetchall()
        self.connexion.commit()
        user_data = []
        for d in data :
            user = {}
            user['id'] = d[0]
            user['userId'] = d[1]
            user['profile'] = d[2]
            user['name'] = d[3]
            user['lastname'] = d[4]
            user['birthdate'] = d[5]
            user['birthcity'] = d[6]
            user['classe'] = d[7]
            user['identifiant'] = d[8]
            user_data.append(user)
        return user_data

    def getById(self,userId):
        sql_request = """SELECT * FROM """+str(self.table_name)+""" WHERE user_id = ?"""
        self.cursor = self.connexion.cursor()
        self.cursor.execute(sql_request, (userId,))
        data = self.cursor.fetchone()
        self.connexion.commit()
        return  data

    def update(self,id,newdata) :
        sql_request = """UPDATE """+str(self.table_name)+""" SET user_id=? ,profile=?, name=? ,lastname=? ,b_day=?,b_city=?,class=? ,num_ins=? WHERE id=%s""" %id
        print(sql_request)
        print(newdata)
        # self.cursor = self.connexion.cursor()
        data = self.cursor.execute(sql_request,newdata)
        self.connexion.commit()
        return data

    def delete(self,userId) :
        sql_request = """DELETE FROM """+str(self.table_name)+""" WHERE user_id = ?"""
        self.cursor = self.connexion.cursor()
        self.cursor.execute(sql_request, (userId,))
        self.connexion.commit()

        
        

