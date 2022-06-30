const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    allowedHosts: [
      process.env.VUE_APP_DOMAIN_URL,
    ],
  },
})
