# Base image with specified Ruby version
FROM ruby:3.3.6

# Set environment variables
ENV RAILS_ENV=development \
    NODE_ENV=development \
    BUNDLER_VERSION=2.4.0

# Install required dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    nodejs \
    yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory inside the container
WORKDIR /app

# Install bundler
RUN gem install bundler -v $BUNDLER_VERSION

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby gems
RUN bundle install --jobs 4 --retry 3

# Copy the rest of the application code
COPY . .

# Expose port 3000 for the Rails server
EXPOSE 3000

# Command to start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
