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
