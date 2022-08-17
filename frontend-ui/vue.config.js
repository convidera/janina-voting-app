const { defineConfig } = require('@vue/cli-service')

if (process.env.VUE_APP_DEPLOY == "stage") {
    module.exports = defineConfig({
        transpileDependencies: true,
    })
} else if (process.env.VUE_APP_DEPLOY == "local") {
    module.exports = defineConfig({
        transpileDependencies: true,
        devServer: {
            allowedHosts: [
                process.env.VUE_APP_DOMAIN_URL,
            ],
        },
    })
}