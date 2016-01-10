/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  Animated,
  AppRegistry,
  Easing,
  StyleSheet,
  Text,
  View,
} = React;

const ScrollTextContainer = require('./app/components/ScrollingTextContainer');

var OCD = React.createClass({
  render: function () {
    <View>
      <Text>Hello, World!</Text>
    </View>
  }
});

AppRegistry.registerComponent('OCD', () => OCD);
