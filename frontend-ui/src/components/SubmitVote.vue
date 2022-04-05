<template>
    <div id="subbtn">
        <button @click ="sendVote" type="submit" id="vote" value="Submit">Vote</button>
    </div>
</template>

<style>
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