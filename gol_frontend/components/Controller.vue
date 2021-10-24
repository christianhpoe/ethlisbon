<template>
  <b-row>
    <b-button
      :class="isRunning ? 'btn-danger m-2' : 'btn-primary m-2'"
      title="play"
      @click="send('play')">
      <span v-show="isRunning">Stop</span>
      <span v-show="!isRunning">Simulate Play</span>
    </b-button>
    <b-button
      class="btn-success m-2"
      title="new"
      v-if="newGame"
      @click="send('new_game')">
      <span >Create New Game</span>
    </b-button>
    <b-button
      class='btn-success m-2'
      v-if="!newGame"
      title="play"
      @click="send('set_newInput')">
      Set Input
    </b-button>
    <b-button
      class='btn-success m-2'
      v-if="!newGame && alive"
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
    newGame: {
      default: false,
      type: Boolean,
    },
    alive: {
      default: false,
      type: Boolean,
    }
  },
  methods: {
    send(event) {
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

