'use strict';

var React = require('react-native');
var {
  Animated,
  Text,
  View
} = React;

const viewStyles = require('./../styles/view');
const textStyles = require('./../styles/text');

const StartScreen = React.createClass({
  getInitialState: function () {
    return {
      displayText: 'TAP TO START',
      fontSize: 50,
      advancingFunction: this.goToInstructions,
      textOpacity: new Animated.Value(1)
    }
  },

  goToInstructions: function () {
    Animated.timing(
      this.state.textOpacity,
      {toValue: 0}
    ).start(() => {
      this.setState({
        displayText: 'Try to keep the screen clear of intrusive thoughts by swiping them left and right',
        fontSize: 25,
        advancingFunction: this.goToGame
      }, () => {
        Animated.timing(
          this.state.textOpacity,
          {toValue: 1}
        ).start()
      })
    })
  },

  goToGame: function () {
    Animated.timing(
      this.state.textOpacity,
      {toValue: 0}
    ).start(() => {
      this.props.navigator.replace({
        name: 'ScrollingTextContainer'
      })
    })
  },

  render: function () {
    return (
      <View style={[viewStyles.centeredContainer, {padding: 20}]}>
        <Animated.Text
          style={{fontSize: this.state.fontSize, opacity: this.state.textOpacity, textAlign: 'center'}}
          onPress={this.state.advancingFunction}>{this.state.displayText}</Animated.Text>
      </View>
    )
  }
});

module.exports = StartScreen;
