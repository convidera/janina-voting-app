<template>
    <div id="selector">
        <div class="green boxes">
            <input type="radio" id="c" name="lang" value="C" checked>
            <label for="c">C</label>
        </div>
        <div class="purple boxes">
            <input type="radio" id="cpp" name="lang" value="cpp">
            <label for="cpp">C++</label>
        </div>
        <div class="green boxes">
            <input type="radio" id="csharp" name="lang" value="csharp">
            <label for="csharp">C#</label>
        </div>
        <div class="purple boxes">
            <input type="radio" id="java" name="lang" value="java">
            <label for="java">Java</label>
        </div>
        <div class="green boxes">
            <input type="radio" id="python" name="lang" value="python">
            <label for="python">Python</label>
        </div>
        <div class="purple boxes">
            <input type="radio" id="ruby" name="lang" value="ruby">
            <label for="ruby">Ruby</label>
        </div>
    </div>
</template>

<style>
    #selector {
        margin-top: 100px;
        display: flex;
        justify-content: center;
    }

    .boxes {
        float: left;
        padding-top: 8px;
        width: 100px;
        height: 30px;
    }

    .green {
        background: #a9f16d;
        
    }
    .purple {
        background: #e75581;
        width: 100px;
        height: 30px;
    }
</style>