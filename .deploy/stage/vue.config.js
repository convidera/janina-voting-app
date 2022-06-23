const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  // devServer: {
  //     proxy: 'https://' + process.env.VUE_APP_DOMAIN_URL,
  //   }
})