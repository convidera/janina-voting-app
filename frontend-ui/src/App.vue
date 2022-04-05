<template>
  <h1>{{ title }}</h1>
  <WhoIs @nameChanged="nameChanged" />
  <LangSelect />

    <div id="subbtn">
        <button @click ="sendVote" id="vote">Vote</button>
    </div>
</template>


<script>
import WhoIs from './components/WhoIs.vue'
import LangSelect from './components/LangSelect.vue'


export default {
  name: 'App',
  components: { WhoIs, LangSelect },
  data() {
    return {
      title: "What is your favourite programming language?",
      username: "",
      progrLang: "",
    }
  },
  methods: {
    nameChanged(name) {
      this.username = name;
    },


    sendVote() {
      
      let progrLang = document.querySelector('.langSel[checked="true"]').value;

      console.log(this.username);
      console.log(progrLang);


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
      var data = JSON.stringify({ "username": this.username, "progrLang": progrLang.value });

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
