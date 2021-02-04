<template>
  <div>

    <div style="position: relative; height:60px; opacity: 70%; background-color: #2c3e50"></div>

    <div class="dailyEventButton">
      <vk-button>test</vk-button>
    </div>

  </div>
</template>

<script>

export default {
  name: 'App',
  components: {

  },

  data() {
    return {
      level: 43,
      name: "Rubylium",
    };
  }


}
</script>

<style scoped>

.dailyEventButton {
  position: relative;
  top: 30%;
  margin-right: 20%;
  width: 150px;
}
</style>
