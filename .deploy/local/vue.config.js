const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    allowedHosts: [
      'www.janina.test',
      'janina.test',
      'www.janina.test/api/',
      'janina.test/api/',
      'www.janina.test/api/get-csrf',
      'janina.test/api/get-csrf',
    ],
  },
})
