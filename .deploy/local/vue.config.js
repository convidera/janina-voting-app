const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    allowedHosts: [
      'www.' + process.env.VUE_APP_DOMAIN_URL,
      process.env.VUE_APP_DOMAIN_URL,
      // 'www.janina.test/api/',
      // 'janina.test/api/',
      // 'www.' + process.env.VUE_APP_DOMAIN_URL + '/' + process.env.VUE_APP_URI_ENTRYP_PATH + process.env.VUE_APP_URI_CSRF_PATH,
      // process.env.VUE_APP_DOMAIN_URL + '/' + process.env.VUE_APP_URI_ENTRYP_PATH + process.env.VUE_APP_URI_CSRF_PATH,
    ],
  },
})
