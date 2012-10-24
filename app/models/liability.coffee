Spine = require('spine')

class Liability extends Spine.Model
	@configure 'Liability', 'person', 'expense', 'frequency', 'outlet', 'hours'
	@extend Spine.Model.Local

module.exports = Liability