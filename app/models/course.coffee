Spine = require('spine')
require('spine/lib/relation')
require('atmos2/lib/spine')

class Course extends Spine.Model
  @configure 'Course', 'name'

  @hasMany "pages", "models/page"

  @extend Spine.Model.Atmosphere
  
window.Course = Course
module.exports = Course