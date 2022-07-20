<template>
    <div id="who_is">
        <h2>Who are you?</h2>
        <input @change="addname" v-model="usernamedata" type="text" id="userinput" name="name" required>
    </div>
</template>

<script>
export default {
    data() {
       return {
            usernamedata: ""
       } 
    },

    methods: {
        addname() {
            this.$emit('name-changed', this.usernamedata);
        }
    }
}
</script>


<style>
    #userinput {
        background: #95d4ff;
        width: 200px;
        height: 20px;
    }
</style>