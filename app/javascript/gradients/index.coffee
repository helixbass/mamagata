import ReactDOM from 'react-dom'
import getApp from './helpers/getApp'

document.addEventListener 'DOMContentLoaded', ->
  ReactDOM.render(
    do getApp
    document.body.appendChild document.createElement 'div'
  )
