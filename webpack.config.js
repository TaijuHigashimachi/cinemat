module.exports = {
  module: {
    rules: [
      {
        test: /node_modules\/(.+)\.css$/,
        use: [
          {
            loader: 'style-loader',
          },
          {
            loader: 'css-loader',
            options: {
              sourceMap: IS_DEVS,
            },
          },
        ],
        sideEffects: true
      }
    ]
  }
}
