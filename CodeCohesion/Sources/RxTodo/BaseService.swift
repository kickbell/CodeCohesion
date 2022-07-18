//
//  BaseService.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/18.
//


class BaseService {
  unowned let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }
}
