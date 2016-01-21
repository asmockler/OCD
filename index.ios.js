'use strict';

var React = require('react-native');
var {
  Animated,
  AppRegistry,
  Easing,
  Navigator,
  StyleSheet,
  Text,
  View,
} = React;

const Routes = require('./app/routes');

var OCD = React.createClass({
  render: function () {
    return (
      <Navigator
        initialRoute={Routes['StartScreen']}
        configureScene={() => {
          return Navigator.SceneConfigs.FloatFromRight;
        }}
        renderScene={(route, navigator) => {
          return React.createElement(Routes[route.name].component, {navigator});
        }}
        />
    )
  }
});

AppRegistry.registerComponent('OCD', () => OCD);
