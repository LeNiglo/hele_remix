'use strict'

const User = use('App/Models/User')

const { pwd_generate } = use('App/Helpers')
const { validateAll } = use('Validator')
const { ValidationException } = use('@adonisjs/validator/src/Exceptions')

class AuthController {

  async register ({request, auth, response}) {

    const validation = await validateAll(request.all(), {
      phone: 'required|unique:users|regex:^0[6-7](\\d{2}){4}$',
      username: 'required|unique:users',
      age: 'required|integer|above:10',
      region_id: 'required|integer',
      establishment_code: 'required|string',
    })

    if (validation.fails()) {
      throw new ValidationException(validation.messages(), 400)
    }

    const password = pwd_generate(10)

    let user = new User()
    user.phone = request.input('phone')
    user.username = request.input('username')
    user.region_id = request.input('region_id')
    user.birthyear = new Date().getFullYear() - request.input('age')
    user.password = password

    await user.save()

    return response.status(201).json({
      user,
      password
    })
  }

  async login ({ request, auth, response }) {

    const validation = await validateAll(request.all(), {
      phone: 'required_without_all:username,email',
      username: 'required_without_all:phone,email',
      email: 'required_without_all:phone,username',
      password: 'required',
    })

    if (validation.fails()) {
      throw new ValidationException(validation.messages(), 400)
    }

    let query = User.query().isActive()

    if (request.input('phone', false) !== false) {
      query.where('phone', request.input('phone').replace(/[.| ]/g, ''))
    } else if (request.input('username', false) !== false) {
      query.where('username', request.input('username'))
    } else if (request.input('email', false) !== false) {
      query.where('email', request.input('email'))
    }

    let user = await query.firstOrFail()

    if (await auth.attempt(user.phone, request.input('password'))) {
      let access_token = await auth.withRefreshToken().generate(user)

      return response.json({
        user,
        access_token
      })
    }
  }

  async refreshToken ({ request, auth, response }) {

    const validation = await validateAll(request.all(), {
      refresh_token: 'required',
    })

    if (validation.fails()) {
      throw new ValidationException(validation.messages(), 400)
    }

    const refreshToken = request.input('refresh_token')

    let access_token = await auth.newRefreshToken().generateForRefreshToken(refreshToken)

    return response.json({
      access_token
    })
  }

  async me ({ request, auth, response }) {

    return response.json({ 'user': auth.user })
  }


}

module.exports = AuthController
