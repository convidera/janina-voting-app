<template>
  <h1>{{ title }}</h1>
  <WhoIs />
  <LangSelect />
  <SubmitVote />
</template>

<script>
import WhoIs from './components/WhoIs.vue'
import LangSelect from './components/LangSelect.vue'
import SubmitVote from './components/SubmitVote.vue'

export default {
  name: 'App',
  components: { WhoIs, LangSelect, SubmitVote },
  data() {
    return {
      title: "What is your favourite programming language?"
    }
  },
  methods: {
    sendVote() {
      let username = document.querySelector('#userinput');
      let progrLang = document.querySelector('.langSel[checked="true"]');


      // Creating a XHR object
      let xhr = new XMLHttpRequest();
      let url = "http://127.0.0.1:8000/";
  
      // open a connection
      xhr.open("POST", url, true);

      // Set the request header i.e. which type of content you are sending
      xhr.setRequestHeader("Content-Type", "application/json");

      // Create a state change callback
      xhr.onreadystatechange = function () {
          if (xhr.readyState === 4 && xhr.status === 200) {

              //Deliver results page from backend response

          }
      };

      // Converting JSON data to string
      var data = JSON.stringify({ "username": username.value, "progrLang": progrLang.value });

      // Sending data with the request
      xhr.send(data);
    }
  } 
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
</style>
