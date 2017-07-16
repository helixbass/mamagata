import {createStore, applyMiddleware} from 'redux'
import {logger} from 'redux-logger'
import ReduxThunk from 'redux-thunk'
import App from '../components/App'
import rootReducer from '../reducers'

export default ->
  store = createStore rootReducer,
    applyMiddleware ReduxThunk, logger

  %App{ store }
