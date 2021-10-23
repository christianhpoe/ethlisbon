<template>
  <b-row>
    <b-button
      :class="isRunning ? 'btn-danger m-2' : 'btn-success m-2'"
      title="play"
      @click="send('play')">
      <span v-show="isRunning">Stop</span>
      <span v-show="!isRunning">Play</span>
    </b-button>
    <b-button
      class="btn-success"
      title="new"
      @click="send('new_game')">
      <span >Create New Game Game</span>
    </b-button>
    <b-button
      class='btn-success m-2'
      v-if="!newGame"
      title="play"
      @click="send('set_input')">
      Set Input
    </b-button>
    <b-button
      class='btn-success m-2'
      v-if="!newGame"
      title="play"
      @click="send('set_next_step')">
      Transition to next state
    </b-button>
  </b-row>
</template>

  <script>
export default {
  props: {
    isRunning: {
      default: false,
      type: Boolean,
    },
    mainComponent: {
      default: 'gamePage',
      type: String,
    },
    newGame: {
      default: false,
      type: Boolean,
    }
  },
  data() {
    return {};
  },
  methods: {
    /**
     * emits the action that is requested
     * by the client up to the App component.
     *
     * @param {string} event - the event
     */
    send: function(event) {
      this.$emit('send', event);
    },
  },
};
</script>

  <style scoped>
.box {
  padding: 0;
}

.green {
  background-color: hsla(120, 77%, 26%, 0.6);
}
.red {
  background-color: hsla(0, 67%, 31%, 0.6);
}
</style>

