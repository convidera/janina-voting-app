const { defineConfig } = require('@vue/cli-service')
//const fs = require('fs')

module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    // https: {
    //   key: fs.readFileSync('./certs/janina.test+3-key.pem'),
    //   cert: fs.readFileSync('./certs/janina.test+3.pem'),
    // },
    // public: 'https://janina.test:443',
    host: '0.0.0.0',
    port: 80,
    //https: true,
  },
})
