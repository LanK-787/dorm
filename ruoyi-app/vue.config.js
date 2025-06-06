const path = require('path')

module.exports = {
  configureWebpack: {
    resolve: {
      alias: {
        '@': path.resolve(__dirname, 'src')
      }
    }
  },
  css: {
    loaderOptions: {
      sass: {
        implementation: require('sass'),
        sassOptions: {
          outputStyle: 'expanded',
          silenceDeprecations: ['legacy-js-api', 'import']
        }
      },
      scss: {
        implementation: require('sass'),
        sassOptions: {
          outputStyle: 'expanded',
          silenceDeprecations: ['legacy-js-api', 'import']
        }
      }
    }
  },
  chainWebpack: config => {
    // 强制使用 sass 而不是 node-sass
    const types = ['vue-modules', 'vue', 'normal-modules', 'normal']

    types.forEach(type => {
      const sassRule = config.module.rule('sass').oneOf(type)
      const scssRule = config.module.rule('scss').oneOf(type)

      ;[sassRule, scssRule].forEach(rule => {
        rule.use('sass-loader').tap(options => ({
          ...options,
          implementation: require('sass'),
          sassOptions: {
            ...options.sassOptions,
            outputStyle: 'expanded',
            silenceDeprecations: ['legacy-js-api', 'import']
          }
        }))
      })
    })
  }
}
