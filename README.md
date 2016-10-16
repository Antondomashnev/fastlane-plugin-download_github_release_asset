# download_github_release_asset plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-download_github_release_asset)
[![Build Status](https://travis-ci.org/Antondomashnev/fastlane-plugin-download_github_release_asset.svg?branch=master)](https://travis-ci.org/Antondomashnev/fastlane-plugin-download_github_release_asset)
[![codebeat badge](https://codebeat.co/badges/553a0e08-15f7-49bf-bdc6-15c93afd8371)](https://codebeat.co/projects/github-com-antondomashnev-fastlane-plugin-download_github_release_asset)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-download_github_release_asset`, add it to your project by running:

```bash
fastlane add_plugin download_github_release_asset
```

## About download_github_release_asset

This [fastlane](https://github.com/fastlane/fastlane) plugin downloads the GitHub release's asset using the GitHub API. The possible usage of the plugin can be found in example [Fastfile](https://github.com/Antondomashnev/fastlane-plugin-download_github_release_asset/blob/master/fastlane/Fastfile).  
Usually the asset on GitHub is a `.zip` file, so here can be really useful another [plugin](https://github.com/maxoly/fastlane-plugin-unzip) to unzip archive.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane example`.

```ruby
lane :example do |options|
  release_version = options[:release_version]

  github_release = get_github_release(
    url: "octocat/Hello-World",
    version: release_version,
    api_token: "token"
  )

  assets = github_release["assets"]
  selected_assets = assets.select do |asset|
    asset["name"] == "my_asset.zip"
  end

  my_asset_json = selected_assets[0]
  my_asset_url = my_asset_json["url"]
  download_github_release_asset(
    asset_url: my_asset_url,
    destination_path: "./here/my_asset.zip",
    api_token: "token"
  )
end
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/PluginsTroubleshooting.md) doc in the main `fastlane` repo.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Plugins.md).

## About `fastlane`

`fastlane` is the easiest way to automate building and releasing your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
