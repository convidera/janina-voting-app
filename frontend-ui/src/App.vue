<template>
  <div @onload="getCSRF"></div>
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
  <ErrorModal :errorMsg="message" v-if="showError" />
</template>


<script>
import WhoIs from './components/WhoIs.vue'
import LangSelect from './components/LangSelect.vue'
import ErrorModal from './components/ErrorModal.vue'
import axios from 'axios'



axios.defaults.xsrfHeaderName = 'X-csrftoken';
axios.defaults.xsrfCookieName = 'csrftoken';

//Axios sends cookies in its requests automatically, force credentials for every Axios request
axios.defaults.withCredentials = true;


export default {
  name: 'App',
  components: { WhoIs, LangSelect, ErrorModal },
  mounted() {
    document.onreadystatechange = () => {
      if(document.readyState == "complete") {
        this.getCSRF();
      }
    }
  },
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
      showError: false,

      enableDefaultSel: true,
      usernameExists: false,

      message: '',
      info: '',
    }
  },
  methods: {
    getCSRF() {
      console.log(process.env.VUE_APP_DOMAIN_URL) 
      axios.get('https://' + process.env.VUE_APP_DOMAIN_URL + '/' + process.env.VUE_APP_URI_ENTRYP_PATH + process.env.VUE_APP_URI_CSRF_PATH)
      .then(response => (this.info = response))
    },

    nameChanged(name) {
      this.usernameExists = true;
      this.dataForAPI.username = name;
    },

    progrLangChanged(lang) {
      this.enableDefaultSel = false;
      this.dataForAPI.progrLang = lang;
    },

    toggleResultsVisible() {
      this.showIndex = false;
      this.showResults = true;
      this.showError = false;
    },

    toggleErrorVisible() {
      this.showIndex = false;
      this.showResults = false;
      this.showError = true;
    },

    sendVote() {
      if (this.usernameExists) {
        if (this.enableDefaultSel) {
          this.dataForAPI.progrLang = "C";
        }
        axios.post('https://' + process.env.VUE_APP_DOMAIN_URL + '/' + process.env.VUE_APP_URI_ENTRYP_PATH, this.dataForAPI)
        .then(response => {
          if (!response.data.error) {
            this.username = response.data.username;
            this.progrLang = response.data.progrLang;
            this.votes = response.data.votes;
            this.totalVotes = response.data.totalVotes;
            this.toggleResultsVisible();
          } else {
            this.toggleErrorVisible();
            this.message = response.data.error;
          }
        })
        .catch(error => console.log(error));
      } else {
        this.toggleErrorVisible();
        this.message = 'Username is missing'
      }
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

button, input {
  border: none;
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
