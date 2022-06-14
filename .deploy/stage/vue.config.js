// const { defineConfig } = require('@vue/cli-service')
// module.exports = defineConfig({
//   transpileDependencies: true,
// });

const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    allowedHosts: [
      'www.' + process.env.VUE_APP_DOMAIN_URL,
      process.env.VUE_APP_DOMAIN_URL,
    ],
  },
})