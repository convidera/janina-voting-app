<template>
    <div class="errorcon">
        <div class="errorstyle">
        <h1>{{ errorMsg }}</h1>
        </div>
    </div>
</template>

<script>
export default {
    props: ['errorMsg']
}
</script>


<style scoped>
    .errorstyle {
        background: #faa23e;
        border-width: thick;
        border-color: #fa6a3e;
        border-style: dotted;
        width: 500px;
        height: 200px;
        margin-top: 100px;
        padding-top: 100px;
    }

    .errorcon {
        display: flex;
        justify-content: center;
    }
</style>