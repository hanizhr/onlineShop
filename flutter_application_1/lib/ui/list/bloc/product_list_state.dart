part of 'product_list_bloc.dart';

sealed class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

final class ProductListLoading extends ProductListState {}

final class ProductListSuccess extends ProductListState {
  final List<ProductEntity> products;
  final int sort;
  final List<String> sortName;

  const ProductListSuccess(this.products, this.sort, this.sortName);
  @override
  // TODO: implement props
  List<Object> get props => [products, sort, sortName];
}

final class ProductListError extends ProductListState {
  final AppException exception;

  const ProductListError(this.exception);
  @override
  // TODO: implement props
  List<Object> get props => [exception];
}
