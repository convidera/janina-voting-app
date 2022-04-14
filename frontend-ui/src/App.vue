<template>
  <div v-if="showIndex">
    <h1>{{ title }}</h1>
    <WhoIs @nameChanged="nameChanged" />
    <LangSelect @progrLangChanged="progrLangChanged" />

    <div id="subbtn">
        <button @click ="sendVote" id="vote">Vote</button>
    </div>
  </div>
  <div v-if="showResults">
    <h1>User {{ username }} voted {{ progrLang }}</h1>
    <h2>There were {{ votes }} on {{ progrLang }} of all {{ totalVotes }} votes</h2>
  </div>
</template>


<script>
import axios from 'axios'
import WhoIs from './components/WhoIs.vue'
import LangSelect from './components/LangSelect.vue'


export default {
  name: 'App',
  components: { WhoIs, LangSelect },
  data() {
    return {
      title: "What is your favourite programming language?",
      
      dataForAPI: {
        username: '',
        progrLang: '',
      },
      
      votes: 0,
      totalVotes: 0,

      showIndex: true,
      showResults: false,
    }
  },
  methods: {
    nameChanged(name) {
      this.dataForAPI.username = name;
    },

    progrLangChanged(lang) {
      this.dataForAPI.progrLang = lang;
    },

    toggleResultsVisible() {
      this.showIndex = false;
      this.showResults = true;
    },

    sendVote() {
      const httpClient = axios.create({ 
        xsrfHeaderName: 'X-CSRF-Token',
        xsrfCookieName: 'csrftoken',
        withCredentials: true
      });


      httpClient.get('http://0.0.0.0:8000/api/get-csrf');

      //const csrftoken = getCookie('csrftoken');

      httpClient.post('http://0.0.0.0:8000/api/', this.dataForAPI)
      //axios.post('https://jsonplaceholder.typicode.com/posts', this.dataForAPI)
        .then(response => console.log(response))
        .catch(error => console.log(error));

      // // Creating a XHR object
      // let xhr = new XMLHttpRequest();

      // //Django server path
      // let url = "http://127.0.0.1:8000/api";
  
      // // open a connection
      // xhr.open("POST", url, true);

      // // Set the request header i.e. which type of content you are sending
      // xhr.setRequestHeader("Content-Type", "application/json");

      // // Create a state change callback
      // xhr.onreadystatechange = function () {
      //     if (xhr.readyState === 4 && xhr.status === 200) {
      //       const json_response = xhr.responseText;
      //       const responseObj = JSON.parse(json_response);
      //       this.username = responseObj.username;
      //       this.progrLang = responseObj.progrLang;
      //       this.votes = responseObj.votes;
      //       this.totalVotes = responseObj.totalVotes;
      //       this.toggleResultsVisible();
      //     }
      // };

      // // Converting JSON data to string
      // var data = JSON.stringify({ "username": this.username, "progrLang": this.progrLang });

      // // Sending data with the request
      // xhr.send(data);
    }
  } 
}

function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            // Does this cookie string begin with the name we want?
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}



</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

#subbtn {
    margin-top: 100px;
}

#vote {
    background:#faa23e;
    width: 80px;
    height: 60px;
    border-radius: 15px;
}
</style>
