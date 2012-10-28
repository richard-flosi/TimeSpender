Stack = require('spine/lib/manager').Stack

class Pages extends Spine.Stack
    controllers:
        home: require('controllers/home')
        assets: require('controllers/assets')
        investments: require('controllers/investments')
        liabilities: require('controllers/liabilities')
        balance: require('controllers/balance')
        contact: require('controllers/contact')
    routes:
        '/home': 'home'
        '/assets': 'assets'
        '/investments': 'investments'
        '/liabilities': 'liabilities'
        '/balance': 'balance'
        '/contact': 'contact'
    default: 'home'

module.exports = Pages
