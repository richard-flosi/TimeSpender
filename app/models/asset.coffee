Spine = require('spine')

class Asset extends Spine.Model
    @configure 'Asset', 'person', 'income', 'frequency', 'source', 'hours'
    @extend Spine.Model.Local

module.exports = Asset
