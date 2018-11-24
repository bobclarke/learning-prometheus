var express = require('express');
var app = express();

let messageModule = require('./module');
let message = messageModule.getMessage()

app.get('/', function(req, res){
   res.send(message);
});

app.listen(3000);























































/* 
const express = require('express')
const bodyParser= require('body-parser')
const app = express()
const MongoClient = require('mongodb').MongoClient
app.set('view engine', 'ejs');

MongoClient.connect(
  'mongodb://quotesuser:quotesuser1@ds143593.mlab.com:43593/starwars', 
  {useNewUrlParser: true} ,
  (err, client) => {

    if (err) return console.log(err)
    db = client.db('starwars') // whatever your database name is

    app.listen(3000, () => {
      console.log('listening on 3000')
    })
  }
)

//app.use(bodyParser.urlencoded({extended: true}))


app.get('/', (req, res) => {
  var cursor = db.collection('quotes')
    .find()
    .toArray(function(err,result){
      if(err){ return console.log(err)}
      res.setHeader('Content-Type', 'text/html');
      res.setHeader('ETag', 'foo');
      res.charset = 'ISO-8859-1'
      res.render('index.ejs', {quotes: result});
    });
})

app.post('/quotes', (req, res) => {
  db.collection('quotes').save(req.body, (err, result) => {
    if (err) return console.log(err)

    console.log('saved to database')
    res.redirect('/')
  })
})
*/
