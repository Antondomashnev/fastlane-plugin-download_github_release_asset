describe Fastlane::Actions::DownloadGithubReleaseAssetAction do
  describe "download_github_release_asset_action" do
    context "when success" do
      before do
        stub_request(:get, "https://api.github.com/repos/octocat/Hello-World/releases/assets/1?access_token=1234567890").
          with(headers: { 'Accept' => 'application/octet-stream', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'fastlane-plugin_download_github_release_asset' }).
          to_return(status: 200, body: "", headers: {})
      end

      it "downloads the file from a remote server" do
        url = "https://api.github.com/repos/octocat/Hello-World/releases/assets/1"
        result = Fastlane::FastFile.new.parse("lane :test do
          download_github_release_asset(asset_url: '#{url}', destination_path: './here/release_asset', api_token: '1234567890')
        end").runner.execute(:test)
        expect(result).to be true
      end
    end

    context "when fails" do
      before do
        stub_request(:get, "https://api.github.com/repos/octocat/Hello-World/releases/assets/2?access_token=1234567890").to_timeout
      end

      it "properly handles network failures" do
        expect do
          url = "https://api.github.com/repos/octocat/Hello-World/releases/assets/2"
          result = Fastlane::FastFile.new.parse("lane :test do
            download_github_release_asset(asset_url: '#{url}', destination_path: './here/release_asset', api_token: '1234567890')
          end").runner.execute(:test)
        end.to raise_error "Error fetching release's asset: execution expired"
      end
    end
  end
end
