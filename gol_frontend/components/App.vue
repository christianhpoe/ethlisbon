<template>
  <div class="GOL">
    <section class="hero primary-background is-fullheight">
      <div v-if="loading">
        <h1 class="text-center">The App is loading...</h1>
        <h1 class="text-center">Please authenticate with Metamask on the Ronkeby Test Network</h1>
      </div>
      <div v-else class="hero-body m-4">
        <h5 class="text-left ml-3" v-if="activeGame" @click="toggleActiveGame()">Back</h5>
        <h1 class="text-center">Game of Life</h1>
        <div v-if="!activeGame">
          <b-button
          class="btn-success ml-auto m-2"
          title="new_game"
          @click="newGame()">
          New Game</b-button>
          <b-table striped hover :items="items" :fields="fields">
            <template #cell(go_to)="data">
              <b-button @click="setActiveGame(data)">Go To</b-button>
            </template>
          </b-table>
        </div>
        <div v-else class="container is-paddingless">
          <div class="columns box is-fullwidth is-gapless">
            <div class="column is-12">
              <transition
                mode="out-in"
                name="fade">
                <keep-alive>
                  <app-grid
                    v-if="mainComponent == 'gamePage'"
                    :message="message"
                    :import-token="importToken"
                    :active-game="activeGame"
                    :current-speed="speed"
                    @exportToken="set_newInput($event)" 
                    @new_game="exportNewGame($event)"
                    />

                  <app-info v-if="mainComponent == 'infoPage'"/>
                </keep-alive>
              </transition>
            </div>
          </div>
          <div class="container">
          <div class="columns ">
            <div class="column is-fullwidth">
              <app-controller
                :is-running="isRunning"
                @send="delegate($event)"
                :newGame="createNewGame"/>     
            </div>
          </div>
        </div>
        </div>
        
      </div> 
    </section>
  </div>
</template>

<script>
// Imports
import Controller from './Controller.vue';
import Grid from './Grid.vue';
import {setInterval, clearInterval} from 'timers';
import getWeb3 from "./getWeb3";
import AllGames from "../../build/contracts/AllGames.json"

export default {
  name: 'App',
  components: {
    'app-grid': Grid,
    'app-controller': Controller,
  },
  data() {
    return {
      loading: true,
      accounts: null,
      networkId: null,
      web3: null,
      LocalAllGames: null,
      activeGame: false,
      createNewGame: false,
      activeId: null,
      items: [],
      fields: [
        {
          key: '_counterInitialInputs',
          label: 'Initial Inputs',
          sortable: true
        },
        {
          key: '_alive',
          label: 'Game Alive',
          sortable: true
        },
        {
          key: '_gameContract',
          label: 'ERC20 Owner Contract',
          sortable: true
        },
        {
          key: "go_to",
          label: "Go to"
        }
      ],
      message: '',
      importToken: '',
      exportToken: '',
      isRunning: false,
      isNavbar: false,
      isImport: false,
      isExport: false,
      speed: 100,
      intervalID: 0,
      mainComponent: 'gamePage',
    };
  },
  created() {},
  methods: {
    toggleActiveGame() {
      this.activeGame = !this.activeGame
      this.createNewGame = false
      if (!this.activeGame) {
        this.activeId = null
      }
    },
    newGame() {
      this.activeGame = true
      this.createNewGame = true
    },
    setActiveGame(game) {
      this.convertImport(game.item._state)
      this.toggleActiveGame()
      this.activeId = game.item._tokenId
      this.$nextTick(() => {
        this.import()
      })
    },
    async getItems() {
      // Set our items to empty array to refresh
      this.items = []

      // Get amount of items in existence
      const lastIndex = await this.LocalAllGames.methods.lastIndex().call()

      // Get all items and push into local items array
      for (let i = 0; i < lastIndex; i++) {
        let game = await this.LocalAllGames.methods.games(i).call()
        let state = await this.LocalAllGames.methods.getState(i).call()
        game._state = state
        this.items.push(game)
        if (this.activeId === game._tokenId) {
          this.convertImport(game._state)
          this.$nextTick(() => {
            this.import()
          })
        }
      }
    },
    listenToStateEvent() {
      // Assing that to this for internal use
      let that = this
      this.LocalAllGames.events.StateChange().on("data", async function() {
        /// Get Items because fired events means, that something happends
        await that.getItems()     
      })   
    },
    delegate(event) {
      if (event === 'play') {
        this.isRunning = !this.isRunning;
        this.restartInterval();
      } else if (event === 'importSession') {
        this.isImport = true;
      } else if (event === 'exportSession') {
        this.updateMessage('exportSession');
      } else if (event === 'set_newInput') {
        this.updateMessage('new_input');
      } else if (event === 'new_game') {
        this.updateMessage('new_game');
      } else if (event === 'slowDown') {
        this.speed > 100 ? this.changeSpeed(-100) : this.changeSpeed(-20);
        this.restartInterval();
      } else if (event === 'set_next_step') {
        this.nextStep();
      } else if (event === 'import') {
        this.import()
      } else {
        this.updateMessage(event);
      }
    },
    
    updateMessage(newMessage) {
      this.message = newMessage;
      this.$nextTick(this.resetMessage);
    },
    
    resetMessage() {
      this.message = '';
    },
    restartInterval() {
      clearInterval(this.intervalID);
      if (this.isRunning) {
        this.intervalID = setInterval(
          this.updateMessage,
          50000 / this.speed,
          'nextStep'
        );
      }
    },
    
    changeSpeed(speed) {
      this.speed += speed;
      if (this.speed < 20) {
        this.speed = 20;
      } else if (this.speed > 500) {
        this.speed = 500;
      }
    },
    
    importSession() {
      this.updateMessage('importSession');
      this.isImport = false;
    },
    exportSession(exportToken) {
      this.exportToken = exportToken;
      this.isExport = true;
    },
    async set_newInput(exportToken) {
      this.exportToken = exportToken;
      this.isExport = true;
      let result = await this.LocalAllGames.methods.inputState(this.activeId, exportToken).send({from: this.accounts[0]})
      console.log(result)
      alert("Success, new state was saved")

    },
    async exportNewGame(exportToken) {
      this.exportToken = exportToken;
      this.isExport = true;
      let result = await this.LocalAllGames.methods.mint(exportToken).send({from: this.accounts[0]})
      this.toggleActiveGame()
    },
    async nextStep() {
      let result = await this.LocalAllGames.methods.transitionToNewState(this.activeId).send({from: this.accounts[0]})
    },
    convertImport(token) {
      let arr = []
      token.forEach(val => {
        arr.push(Number(val))
      })
      let returnString = ""
      arr.forEach((value, index) => {
        if (index < 10 && value === 1) {
          returnString += "[" + index + "," + 0 + "]"
        } else if (value === 1) {
          let splitIndex = index.toString().split("")
          returnString += "[" + splitIndex[1] + "," + splitIndex[0] + "]"
        }
      })
      this.importToken = returnString
    },
    import(){
      this.isImport = true
      this.importSession()
    },
  },
  async mounted() {
      try {
        // Get network provider and web3 instance.
        this.web3 = await getWeb3()
        // Use web3 to get the user's accounts.
        this.accounts = await this.web3.eth.getAccounts()

        // Get the contract instances.
        this.networkId = await this.web3.eth.net.getId()

        this.LocalAllGames = new this.web3.eth.Contract(
          AllGames.abi,
          AllGames.networks[this.networkId] && AllGames.networks[this.networkId].address,
        )
        
        // Register evt handler
        this.listenToStateEvent()

        // Get Items to show
        await this.getItems()
        this.loading = false
      } catch (error) {
        // Catch any errors for any of the above operations.
        console.error(
          `Failed to load web3, accounts, or contract. Check console for details.`,
        );
        console.error(error);
      }
    }
};
</script>

<style lang="css">
html,

#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #fff;
}

.hero-body {
  align-items: stretch !important;
  padding-top: 18px;
  padding-bottom: 12px;
}

.container {
  max-width: 600px !important;
}

.footer {
  padding: 1rem;
  background-color: transparent;
}


.hr {
  position: relative;
  border-top: 2px solid #414b5c;
  margin: 0px;
  bottom: 0;
}


.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.35s linear;
}
.fade-enter,
.fade-leave-active {
  opacity: 0;
}
</style>
