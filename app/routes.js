'use strict'

const React = require('react-native')

const Routes = {
  'StartScreen': {
    name: 'StartScreen',
    component: require('./components/startScreen'),
    index: 0
  },

  'ScrollingTextContainer': {
    name: 'ScrollingTextContainer',
    component: require('./components/scrollingTextContainer'),
    index: 0
  },

  'InfoScreen': {
    name: 'InfoScreen',
    component: require('./components/infoScreen'),
    index: 0
  }
}

module.exports = Routes
