module Web.FrontController where

import IHP.RouterPrelude
import IHP.LoginSupport.Middleware

import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)

-- Controller Imports
import Web.Controller.Users
import Web.Controller.Posts
import Web.Controller.Static
import Web.Controller.Sessions

instance FrontController WebApplication where
    controllers = 
        [ startPage WelcomeAction
        , parseRoute @SessionsController -- <-- sessions stuff
        -- Generator Marker
        , parseRoute @UsersController
        , parseRoute @PostsController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
        initAuthentication @User

