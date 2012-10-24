Stack = require('spine/lib/manager').Stack

class Pages extends Spine.Stack
    controllers:
        home: require('controllers/home')
        assets: require('controllers/assets')
        liabilities: require('controllers/liabilities')
        savings: require('controllers/savings')
        balance: require('controllers/balance')
        contact: require('controllers/contact')
    routes:
        '/home': 'home'
        '/assets': 'assets'
        '/liabilities': 'liabilities'
        '/savings': 'savings'
        '/balance': 'balance'
        '/contact': 'contact'
    default: 'home'

module.exports = Pages
