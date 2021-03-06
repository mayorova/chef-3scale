#
# Cookbook Name:: chef-3scale
# Recipe:: default
#
# Copyright (C) 2015 3scale Inc. (https://3scale.net)
#
# All rights reserved - Do Not Redistribute
#
# rubocop:disable LineLength

class Chef
  class Recipe
    # 3scale Helper functions
    class Helpers
      def self.unzip(zipfile, dest_dir)
        Archive::Zip.extract(zipfile, dest_dir)
      end

      def self.fetch_from_url(url, dest_dir)
        response = HTTPClient.get(url, follows_redirect: true)
        raise "Could not fetch files from URL: #{url}" unless response.status == 200
        zip_path = File.join(dest_dir, 'bundle.zip')
        File.open(zip_path, 'w') { |file| file.write(response.body) }
        unzip(zip_path, dest_dir)
      end

      def self.fetch_3scale_config(admin_domain, provider_key, dest_dir)
        path = '/admin/api/nginx.zip'
        url = "https://#{admin_domain}-admin.3scale.net#{path}?provider_key=#{provider_key}"
        fetch_from_url(url, dest_dir)
      end

      def self.link_files(from_dir, openresty_dir)
        FileUtils.symlink(Dir["#{from_dir}/*"], openresty_dir, force: true)
      end
    end
  end
end
